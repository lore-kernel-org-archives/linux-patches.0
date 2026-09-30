Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C22C4FB9C8;
	Wed, 30 Sep 2026 15:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782843; cv=none; b=QEPQzcEhMb7i7LtGEGsYOihVpzf+2sZj29S+62LHYX2s1ofn44WylDl//Dra/mp2zVkOtJm2Zcqz+MCLogY4Zf7EQmDPQMKwDnQ/WY5hxEKvsuPoFIkzgTToVpHnuXJvBEB5mbTR9UGjURWeiUx6E8lXe6nl4VigzYVPYKv9g28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782843; c=relaxed/simple;
	bh=ZwnxE+a917+XO+V3H8uWh9osFnAN0uqmPTHg3Y8uKhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EC2IrXk0lBBWJMTGde1gor65CB3Yo/wfti0hACW6H7asRNT2LuxLYuYfox5ZhMTTYpwXA+zhPKHx2u93ak3sTfBypCs15ICaITGRPXufXgOsxkxTFEHd3bTJwc9x78SkhsfbFVR/kOeP4LgWRNm28CkDZ46w7ppNyxeIKySFIA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wd0DdF2B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wd0DdF2B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF4181F00898;
	Wed, 30 Sep 2026 15:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782837;
	bh=97mnuUmNX0tnyYIkKIew9w6DZuIlOl9KZeItKnE385I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wd0DdF2B6U7f7dH1ZL61G6fWcaZWf6qsb5GbyN4Uzu2lfNtJH/AjuhBW0MmbOI7rA
	 wBkYlKITmh2Sd9MeWQ6bfLVOK9Lfe9RPy5T9Vx5zaqvdJkYwbtkaah0ujkT2pFEK2k
	 QnKsYxUwt/dddssyie3xTLmlea/eA2NbGNR9G3UY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 187/595] Revert "Bluetooth: btusb: Add ASUS USB-BT600 for Realtek 8761CU"
Date: Wed, 30 Sep 2026 17:21:20 +0200
Message-ID: <20260930152351.764143857@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 7275e801cc9482bb35a606d3b0c23337f492e92a.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index bdde7757ffb3d..39dce3ce666bd 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -484,8 +484,6 @@ static const struct usb_device_id blacklist_table[] = {
 	/* Additional Realtek 8761CU Bluetooth devices */
 	{ USB_DEVICE(0x0b05, 0x1bef), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
-	{ USB_DEVICE(0x0b05, 0x1d70), .driver_info = BTUSB_REALTEK |
-						     BTUSB_WIDEBAND_SPEECH },
 
 	/* Additional Realtek 8821AE Bluetooth devices */
 	{ USB_DEVICE(0x0b05, 0x17dc), .driver_info = BTUSB_REALTEK },
-- 
2.53.0



