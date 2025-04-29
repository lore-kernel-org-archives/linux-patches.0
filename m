Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9678A2472B4;
	Tue, 29 Apr 2025 17:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947350; cv=none; b=fFFJ2NI7dpdsgbCu2v3evA4s+ORKWwU0MhS8wThxtZJNGiYiBBMo4lsw0Rlmsv7Iifl4d0hkJbilhI0gZ54s1vnv0S0QK8YlEHgHtZVjSHwQlNlhPa+nMEdJOK1EohiqWgaMPazbnX/N1G4o/K+ECmvu+B1qpzO0yUCHTJw2a44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947350; c=relaxed/simple;
	bh=MovaAcOzhlBhQlvbM/uJA4qPaguWhpW6ivUk8UIoSy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KVM1UnTT0iSxT6pitS+32oEvdW6aUQug5GZ/B3GPVLysLPesZJkSPhwSg3UJwxuLiC35kcb4o26DEIAndAVO1FZUEV5nsyFOkZMYmJWO4r/N1CF6T0WGIhuX2B227y38EtAyXvnNsX6fgNTb2KDJTeA8Z9U9V35VPeUrVGyRsts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TMxD183v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TMxD183v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE66C4CEE3;
	Tue, 29 Apr 2025 17:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947350;
	bh=MovaAcOzhlBhQlvbM/uJA4qPaguWhpW6ivUk8UIoSy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TMxD183vbkMBwzSEe6bM6LJK+M73MEUgSXKNg7oNt2O6cQOHkkABjpXaH0E/VPk8O
	 7HzG+OWDTlwuIgLBf9Y+2Kf4lSakQdA3GUlWBqB1U84OxiaVjFrPWrk7TvJicw8EUP
	 ZWU9HYewzljbI29Q7h+etOAJuhNtHsuf8ZWC8a1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 5.10 252/286] USB: VLI disk crashes if LPM is used
Date: Tue, 29 Apr 2025 18:42:36 +0200
Message-ID: <20250429161118.288978698@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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
 


