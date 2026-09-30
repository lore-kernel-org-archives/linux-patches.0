Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732B53C76AD;
	Wed, 30 Sep 2026 19:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794899; cv=none; b=UbCbZlW47a6HITLibWvPtaQhcCViKyMVWFpqwCYKPuU0/GZ3LisHIgnbjmKYE3wBp985ek3zLfBH9j7DmLKyK2jfl1bJKJYakmdA10WCe2b6Uz6YnWZjF6aIwpJ8ERJj5AAqw64Yt3Veg57uA1Q7ylAiL/YOUl5XbTwhgjtnyjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794899; c=relaxed/simple;
	bh=idr5H8FQCtXTygt/2VyQTnvAnsTSYCen91pVAxJA8Xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pRBhxm4iLVHsf+pcfyo5pQ4aEOZIro0AIDTLKyUmJ29J/zs4DhLJmCYo+QEXDZaDcZyG2D3MJLUUM9s7lh1bdLGuCaOooKlH1hyRmpdJhGrM2qj0zZ271EJQq87d18XVbWcO/ReELeBz56kGD0eotnd41EiL2oKkBtzpWmTuf6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nJyIZzH/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nJyIZzH/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE5E31F00898;
	Wed, 30 Sep 2026 19:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794898;
	bh=1PNV1eVdKpLx2BfHY3Y2brUlOd54Vj1cY4FEm3amIJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nJyIZzH/BjX1+BsmZjy3X4vmJEkCT/N3FzIFnXwusLUlkWTYKt3KpuYZ6EKHDvDny
	 b2dscuvbXiEJ4OKvA+h2fYnw4bb/Z937HJUn9DrcwmaPH0a6UePDcZ0U/gIDDfn2jz
	 l7YtBlERcesVirVNFS/GGscmGkb4HVAlKtfu1pVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0370/1193] Revert "Bluetooth: btusb: Add ASUS USB-BT540 for Realtek 8761CU"
Date: Wed, 30 Sep 2026 17:17:34 +0200
Message-ID: <20260930152442.399318113@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 1b5fb9c40e301491a02d4741dbb5473c11439038.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 872c3b473f039..5372a28b9f750 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -753,10 +753,6 @@ static const struct usb_device_id quirks_table[] = {
 	{ USB_DEVICE(0x37ad, 0x0600), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
 
-	/* Additional Realtek 8761CU Bluetooth devices */
-	{ USB_DEVICE(0x0b05, 0x1bef), .driver_info = BTUSB_REALTEK |
-						     BTUSB_WIDEBAND_SPEECH },
-
 	/* Additional Realtek 8821AE Bluetooth devices */
 	{ USB_DEVICE(0x0b05, 0x17dc), .driver_info = BTUSB_REALTEK },
 	{ USB_DEVICE(0x13d3, 0x3414), .driver_info = BTUSB_REALTEK },
-- 
2.53.0



