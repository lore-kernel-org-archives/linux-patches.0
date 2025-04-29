Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8282E3FFD;
	Tue, 29 Apr 2025 18:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950488; cv=none; b=ea7IxCQcyIeXV8hMxbyLAAhy43ySfqZKMKfS6Ov8K4Ljb/A+UEHCrfpBBMZ9ZocJsnPaGjrt6h0zFDCjgXHKPaKT6mEXNj7gkTyMYOw0EGjq/QEB7IytDv4JTbXSrmrpCPvlU2NDZALP5/JVIyx2eXlovXy6/1xIbGjWbtyIod8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950488; c=relaxed/simple;
	bh=duT78Z4mydSao6P51Ip2IDL31dUNKzbFI4d5RxENiPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OVG5BhalFyI7qDW5oal9ND11rKfdZHZQspiG3RL0RyJBZN1h7gYBByV+d/Y1/uH197SzMNCyhW+jeOI3NiFikz96fa3WIjmeBgv4/fHDmaVbNvpVAGtI7ym1VBQZ96uyzhWl2kNlAVDBtCR1NP1Kxql6m3bAAFjcYS2DYCROyak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oo0r1cb3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oo0r1cb3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC43C4CEE3;
	Tue, 29 Apr 2025 18:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950488;
	bh=duT78Z4mydSao6P51Ip2IDL31dUNKzbFI4d5RxENiPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oo0r1cb3dgNoiqXgjBNE2dl5az6GAz5rL41kFIIOLAKoEciVYvu6nXcvhmrpUSW5i
	 RJ8BvY0NWkuPghNwpCwsF1H8aBm11RO7Wv9Ijry3TEuziRL5milyqJfL5RD1YECPym
	 Q3+6PZdYMwDejduKVSzO832umcNPx3r+CQWUKpgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 6.6 112/204] USB: VLI disk crashes if LPM is used
Date: Tue, 29 Apr 2025 18:43:20 +0200
Message-ID: <20250429161104.018584203@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


