Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C4825334B;
	Tue, 29 Apr 2025 16:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945660; cv=none; b=rzYLOj8Jk5HO05gcxNBB9PnOmGl4O4FARoZB3H0tLrgtHMKRcYKd7NDmDqk29LJANck6av3Wk/X/bNrJVTHpbSs9+xIpylofP/gMUnWTGFfjoldq0lVfaoA0Ui00NgGOCXyMvXtO0cdiRUu2M5wHFJZw5ChdFqbfh5bmOdKWTdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945660; c=relaxed/simple;
	bh=qBF4CKLwSXyqIKiq8tNBsIihqWvUPKXjkCxa8jHtook=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CAbdKwPsa7qpRPwueOGzZnNUBzjjwK0JHoOxnD1hshIz0mX+mlhqRspDtyMzt9/FTdzz3Y1VPKgUFnvctgBV2aijgor4RVCeoBLUvnFlqszSVtB8Hx82ATtSQ87vbV1A1Zbn5TjAeZ6VAxAmprG3lI9/4KgqcZiUpz6sArhsONk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bl8u5//j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bl8u5//j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278D3C4CEEA;
	Tue, 29 Apr 2025 16:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945660;
	bh=qBF4CKLwSXyqIKiq8tNBsIihqWvUPKXjkCxa8jHtook=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bl8u5//jqU4l0V2a7d6aF78Kb38EccOjmabK8HmoyQ/oOXMiK/OPJ5W6f4wghS1Pe
	 VawK820+kaq01Kx1VR6vl/YJ7A3Z70q8u7vmxF0OS4IXvN/f7sTKCiXrKare6Ex0kZ
	 oZ3AcXRbc+xKJ8s9Z4CEUJVffLjk7iJZjxiKVf7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 5.4 158/179] USB: VLI disk crashes if LPM is used
Date: Tue, 29 Apr 2025 18:41:39 +0200
Message-ID: <20250429161055.773672220@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

commit e00b39a4f3552c730f1e24c8d62c4a8c6aad4e5d upstream.

This device needs the NO_LPM quirk.

Cc: stable <stable@kernel.org>
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20250408135800.792515-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -540,6 +540,9 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x2040, 0x7200), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },
 
+	/* VLI disk */
+	{ USB_DEVICE(0x2109, 0x0711), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* Raydium Touchscreen */
 	{ USB_DEVICE(0x2386, 0x3114), .driver_info = USB_QUIRK_NO_LPM },
 


