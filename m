Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA49D2DAFBD;
	Tue, 15 Jul 2025 13:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587745; cv=none; b=QgdF/hC9SuDU8oJps/JPYxALhCFI11N+kQnC9/32KhVgii3wN9rPwN+O1kG86wTlXDwWTrGZFL/9eM2YV22MdcPCLir3+IijUvSpl1WxZDxFxe9WJvTzYJnK4F8R2Rb6vDyeiIAUkUFqmHtyirVFebuhBqjlgqT2ngiwOXbJJgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587745; c=relaxed/simple;
	bh=KzBgGuImW5+Ntubma0XOheCiV7QXwK58FEhBXaLLqHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lJ54HbT9FZsREfr1MikRMFt8U+zqAgU26HvED3eJV6l/HuFJH8KnfWCNtY2DQEXuhujOhSbcWfdbSOcchUuL6dNcihQV4KLmmqpcBpGRQadW7Qz4QKtUiy9V8T69aesf5ajx62nBBpJoE0D+Dp/qLAfNplIXLaD9/1yjbAu84i0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fRIbAsK6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fRIbAsK6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ACE6C4CEE3;
	Tue, 15 Jul 2025 13:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587745;
	bh=KzBgGuImW5+Ntubma0XOheCiV7QXwK58FEhBXaLLqHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fRIbAsK6OT2emTmeFQNRO+nal293/0A7SoA/t6QjUJ10hVZU9mG52n1gaChYV+amr
	 DRnVQ9+E6rwQtuv86NhNIYN53FwrPt0MZ0WlnSV78aZ/TRY1XK0dGVG1Or+BfKYmSm
	 BHYt/JqncL7HOg5zCpdTq9gpq/NUzDJx0UqgO7bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.10 126/208] Logitech C-270 even more broken
Date: Tue, 15 Jul 2025 15:13:55 +0200
Message-ID: <20250715130815.990954930@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

From: Oliver Neukum <oneukum@suse.com>

commit cee4392a57e14a799fbdee193bc4c0de65b29521 upstream.

Some varieties of this device don't work with
RESET_RESUME alone.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20250605122852.1440382-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -224,7 +224,8 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x046a, 0x0023), .driver_info = USB_QUIRK_RESET_RESUME },
 
 	/* Logitech HD Webcam C270 */
-	{ USB_DEVICE(0x046d, 0x0825), .driver_info = USB_QUIRK_RESET_RESUME },
+	{ USB_DEVICE(0x046d, 0x0825), .driver_info = USB_QUIRK_RESET_RESUME |
+		USB_QUIRK_NO_LPM},
 
 	/* Logitech HD Pro Webcams C920, C920-C, C922, C925e and C930e */
 	{ USB_DEVICE(0x046d, 0x082d), .driver_info = USB_QUIRK_DELAY_INIT },


