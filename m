Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA581DC988;
	Tue, 29 Apr 2025 17:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949532; cv=none; b=MWatEcBv0cARg6Ld3CLGI7CpVV4p3iSlaIyP0s5Ix3kL3VQ/flGVJv6al4M4/xwbL95grorPoe2FepE/WqWj7dRZYqNzF8KUmTKb/6jGufBpf8peGcIiG7LbJBG/MNx/7RizyuLc5fZ6O/QDU1h27SiQlyZAh8ibKiao/vL4Vzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949532; c=relaxed/simple;
	bh=/l70thjsL40qxK8iKVlN7M7TDif7rcxaqiE4RxAb+Ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=acKDfmrjFQftxXxHHGK1bulqZjiUUHis/NorFl3OHdaHhe64xZ1Rz/Nt4Ege1tM1DyIedFoojeXxe8lSMXFwRMv0+VTyAlqjzgxo/VkaGYg7M3vf4qNsXks2qJThCJhhq5S8cwaERR0sIydEwzo/A215izqc/7kBU/QIaqhWz4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MrgSsdqV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MrgSsdqV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203B8C4CEE3;
	Tue, 29 Apr 2025 17:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949531;
	bh=/l70thjsL40qxK8iKVlN7M7TDif7rcxaqiE4RxAb+Ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MrgSsdqVRHQbPqCGzhMvwHGzbIaBrLzbbYlUr4X8FDXzWKmW+3jGOmBnka5B34bey
	 GeI05dunhezsQNXqnTGDOTU98LuKUP+2gxVpfgnb7p8M/S8e7NbkNCCOAJqfKgtVRh
	 QqTZJbJZ81QxdXEpTKF/4Rx+Fs8X2EPZcveO236Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 5.15 318/373] USB: VLI disk crashes if LPM is used
Date: Tue, 29 Apr 2025 18:43:15 +0200
Message-ID: <20250429161136.194748932@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -539,6 +539,9 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x2040, 0x7200), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },
 
+	/* VLI disk */
+	{ USB_DEVICE(0x2109, 0x0711), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* Raydium Touchscreen */
 	{ USB_DEVICE(0x2386, 0x3114), .driver_info = USB_QUIRK_NO_LPM },
 


