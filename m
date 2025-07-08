Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5922D877F;
	Tue,  8 Jul 2025 16:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992151; cv=none; b=JLuyi1r17zAT+Pp5YrE17Ol28Os1rXbN3m45NBLIM6/ZnHY18+xyomTdh7NU8cs8NLUmgYUq3+nDmLnVJJxV6H7gkDP06cLV866GwTeeYgkQ9K+eQOGaszlA7sL6lqLIJJ8fHqdWpQ+2FUcfMXft2zO3dHKlAXgJc8JncSWsS/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992151; c=relaxed/simple;
	bh=C/73yHCoZQE4HSnSCGQKaAGHaC+jQzMaM7T4uAZKJx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bZFf23LdypD0UzFiesGTkhOqsyhC0nWTIujcgDYSkxe9zvsoa5SyMY4iNdJ5cexpx7zqECJdP2uJQDJ7HADpRoD3nfaNhVnr0wn5PAa9fusYCx4+Tw0wUzVFvWYaNUWJJdJG9srP0BoQBdHS4CzPcuHodUPwdwNdWBkUbHCB8N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IrlSpvna; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IrlSpvna"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16C82C4CEED;
	Tue,  8 Jul 2025 16:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992151;
	bh=C/73yHCoZQE4HSnSCGQKaAGHaC+jQzMaM7T4uAZKJx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IrlSpvnajUkB8UUGZTtOttKskPFbzEk338tm5yQ3YQEISfPZaBrB5sG4iiDbPY01M
	 dkk2c2TZVwmAaK8kodCv6Brt14bCTXzWfpTfAhRUVoEz3Q0mf+LbOuuGsZsBi/YNAB
	 ePNDbG1Y9xqmClwgOv5PXbaO6wG6ApPGmFDxoazI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 74/81] Logitech C-270 even more broken
Date: Tue,  8 Jul 2025 18:24:06 +0200
Message-ID: <20250708162227.294198372@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162224.795155912@linuxfoundation.org>
References: <20250708162224.795155912@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


