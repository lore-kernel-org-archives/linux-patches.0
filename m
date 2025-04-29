Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2672E2AE96;
	Tue, 29 Apr 2025 18:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949985; cv=none; b=GwMCTWl79ax20Cs+6ui03q4+/v0mmv7JL4ZZJxzW7GDrpRZoS9TdrxLCrML6GZdxIMTLaro+TCCJqpKZaq88KJpZfDxPE1/NAkFsN0vKkK7zbP5QkZ1f0VDBA9n/FtNa777fvxOONlWFP07y80uD3J3xXA+eIXa+XOeXFzyu408=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949985; c=relaxed/simple;
	bh=myjWf/PlT4KA54ynT7SBMdzEns/iyGXszRI3p+9Rams=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qeTuldFXlm6/EkBBhXJ8SaHegn3JP9pva8zuIst4Gmn2hw8kLgeWGd+TpvRmKI+SrxTCFGgN8ja72BnvogyMpJvoE9nR6IK4yniSYX6yJ2GCpHDUna8LC1cEG7Hqst++L/bP+nuUeD/ysk1xs8WBxBU5d+90Bbg1gd32DCLXWLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vTMK5iwk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vTMK5iwk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6FACC4CEE3;
	Tue, 29 Apr 2025 18:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949985;
	bh=myjWf/PlT4KA54ynT7SBMdzEns/iyGXszRI3p+9Rams=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vTMK5iwk98kbDEJ5TO5KCVniNqCKBjKK3ErBsdhlh4zx/+oPxIl5DrPHt7iA9FfPm
	 YXFWCW+9yJOlrwCjXVQNVyfc5ZQ3dEYQUFmbAhh6PYiN3atBtYjJ/Y+lwdAaVC3RFC
	 ILRkP2mo7a7wJTy6XK4+32ddn8ZFy+ugZMpV2xOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 6.1 092/167] USB: VLI disk crashes if LPM is used
Date: Tue, 29 Apr 2025 18:43:20 +0200
Message-ID: <20250429161055.481905310@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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
@@ -542,6 +542,9 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x2040, 0x7200), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },
 
+	/* VLI disk */
+	{ USB_DEVICE(0x2109, 0x0711), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* Raydium Touchscreen */
 	{ USB_DEVICE(0x2386, 0x3114), .driver_info = USB_QUIRK_NO_LPM },
 


