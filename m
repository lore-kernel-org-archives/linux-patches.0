Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44B1BE46;
	Tue,  8 Jul 2025 16:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993696; cv=none; b=Hkr3RgRh50Do7B1kZTW8oUt5t5CXVcTm2KCI8T1s6GRsitn8abs/zGan/+YVfubF9mTgWQKQlOz3VUrOvByJns4BXi/XOU5yVr77V/tRpK4iSlmDFZrg0AsRg4ijCzAGsLTbmNuD8YRPaCchH/JuM9n8XGsUfOnPuTHiBCNOrZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993696; c=relaxed/simple;
	bh=UDZsli0uLeW8hktkSOOJSwB4He89jNi5xJx2TLYSSAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=doCCjmCRN/SA5BbOz6E06k1OPnUQhbrCT5h83rIIKZ2xb93cT3ynr9haFs50lSrMP1QYHw+MdAzBq/rI96ZdnIYDRYrwBYRg8HQUcXwiOiyW3yYsyDPJ9t+5Cihld3TQjhnETjz4qQjc/XmOlsnmUW+jpoNHC42X45b8z4pLgho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FqUZiZ7q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FqUZiZ7q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 024A0C4CEED;
	Tue,  8 Jul 2025 16:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993696;
	bh=UDZsli0uLeW8hktkSOOJSwB4He89jNi5xJx2TLYSSAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FqUZiZ7qbdJiKb6Vfp3E47qg3QGyRRU6462lJ/g58+aKuKyPOhWCvdu21bdrL5Psh
	 jzpccyq2Fjv3bmO9OGcsDAvCfCIKjV6pOw6tfENue0WTySsnCjpA/KJBaTjQu12Gmp
	 R8Kd8DL9tiuoAlrOU6lyuphbecDPOAg+wwD+2e2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.15 162/178] Logitech C-270 even more broken
Date: Tue,  8 Jul 2025 18:23:19 +0200
Message-ID: <20250708162240.713374799@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -227,7 +227,8 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x046a, 0x0023), .driver_info = USB_QUIRK_RESET_RESUME },
 
 	/* Logitech HD Webcam C270 */
-	{ USB_DEVICE(0x046d, 0x0825), .driver_info = USB_QUIRK_RESET_RESUME },
+	{ USB_DEVICE(0x046d, 0x0825), .driver_info = USB_QUIRK_RESET_RESUME |
+		USB_QUIRK_NO_LPM},
 
 	/* Logitech HD Pro Webcams C920, C920-C, C922, C925e and C930e */
 	{ USB_DEVICE(0x046d, 0x082d), .driver_info = USB_QUIRK_DELAY_INIT },


