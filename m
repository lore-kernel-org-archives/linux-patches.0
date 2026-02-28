Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A037D32AABE
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301121; cv=none; b=qq7TOZMmnZC0FV4fZtxQlk8NUi2YMFCLeHmj4UAFj4y2mSZQcps+SlmvZ6FpEmWR7uK2TvyCDqWPErQ7kQIb0jfy0/3cy1ejvFMyDYByhkrOORH3Z6ekFBNqNzKZvvpMtzbD/aY/6zem3COKbHEHo6zJuKjH0vE8C94tcBml2Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301121; c=relaxed/simple;
	bh=903S7+sSSmdgh1Mfsv4ehIBnuR2dFPRTGLi8PB2YhXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fXi0EKdabWerd5B1xkISMxn2xsuPXXu0YUaaLafTSyl56yHXN0GGAcKLnB+2Xncy1ttfS3fpSSPMNfdlwinS5bXx6LiyoKteUJkXnE03Yw8pBue+rWUgszXAIFrTKjeNcckNjYLr2S94Y29Xlu0luvM13rekieii9iVk17MeXH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fjxBQHzm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fjxBQHzm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05123C2BC87;
	Sat, 28 Feb 2026 17:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301121;
	bh=903S7+sSSmdgh1Mfsv4ehIBnuR2dFPRTGLi8PB2YhXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fjxBQHzmcX0ykyKfJnAa/oJlKAfuia9QEiGSn1yr8NL6xIZ6DNSXu5x95W7AaCwYD
	 YaQmSJZehrkYp7hqOHX1GASVEWlkUa+QAz+QFiSrPRZqH3kXRqpvRUME/6OmIAiD7K
	 8WtE8idLRE3KK9qArUX4Z+Gudzd8DAuRcmskl64zE6+7CyF+9HOA4awcReXPAP/o//
	 YCTW/09LHr9WpSl4ucKGVZpja39ISFdKsOje+f4Tf3171CPwhuhZAiV2B3x8kQC4UY
	 dHhECYRwZx+p+IFKPV3aazJYm9dGpVUjA1Np80a7fuVtzREm5bs2lF95Cp2KkT46Dq
	 5jUoynOG1AStw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jacopo Scannella <code@charlie.cat>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 279/752] Bluetooth: btusb: Add device ID for Realtek RTL8761BU
Date: Sat, 28 Feb 2026 12:39:50 -0500
Message-ID: <20260228174750.1542406-279-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jacopo Scannella <code@charlie.cat>

[ Upstream commit cc6383d4f0cf6127c0552f94cae517a06ccc6b17 ]

Add USB device ID 0x2c0a:0x8761 to the btusb driver fo the Realtek
RTL8761BU Bluetooth adapter.

Reference:
https://www.startech.com/en-us/networking-io/av53c1-usb-bluetooth

Signed-off-by: Jacopo Scannella <code@charlie.cat>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index b70cc8d5e0389..7c7955afa8e8a 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -777,6 +777,7 @@ static const struct usb_device_id quirks_table[] = {
 
 	/* Additional Realtek 8723BU Bluetooth devices */
 	{ USB_DEVICE(0x7392, 0xa611), .driver_info = BTUSB_REALTEK },
+	{ USB_DEVICE(0x2c0a, 0x8761), .driver_info = BTUSB_REALTEK },
 
 	/* Additional Realtek 8723DE Bluetooth devices */
 	{ USB_DEVICE(0x0bda, 0xb009), .driver_info = BTUSB_REALTEK },
-- 
2.51.0

